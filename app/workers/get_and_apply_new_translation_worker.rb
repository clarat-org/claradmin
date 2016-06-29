# frozen_string_literal: true
class GetAndApplyNewTranslationWorker
  include Sidekiq::Worker

  # TODO: reindex connected offers if a category translation was updated
  def perform gengo_order_id
    gengo_order = GengoOrder.find(gengo_order_id)
    order = GengoCommunicator.new.fetch_order gengo_order.order_id

    # ignore unfinished orders (total_job_count != approved_jobs_count)
    return unless order['total_jobs'].to_i == order['jobs_approved'].count

    order['jobs_approved'].each do |job_id|
      get_and_apply_translation_job job_id, gengo_order.expected_slug
    end

    # save updated model (all translations updated) and delete gengo_order
    translated_instance.save!
    gengo_order.delete!
  end

  private

  def get_and_apply_translation_job job_id, expected_slug_prefix
    job = GengoCommunicator.new.fetch_job job_id

    # safety mechanism: gengo-slug must match the expected value
    return unless job['slug'] == "#{expected_slug_prefix}_#{job['lc_tgt']}"

    model, id, field = job['slug'].split(':')
    translated_instance = model.constantize.find(id)
    translation = job['body_tgt']

    translated_instance.send("#{field}=", translation)
  end
end
