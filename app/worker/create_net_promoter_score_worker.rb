# frozen_string_literal: true

class CreateNetPromoterScoreWorker
  include Sneakers::Worker

  from_queue Rails.env.test? ? "#{ENV['CREATE_NPS_QUEUE_NAME']}_test" : ENV['CREATE_NPS_QUEUE_NAME'], { durable: true }

  def work(msg = [{}])
    data = ActiveSupport::JSON.decode(msg)
    pp data
    data.each do |nps|
      create_nps(nps.to_h)
    end
    ack!
    create_log(true, data)
  rescue StandardError => e
    create_log(false, data, { message: e.message })
    reject!
  end

  private

  def create_nps(nps_payload)
    nps = NetPromoterScore.new(
      type: nps_payload["type"],
      touchpoint: nps_payload["touchpoint"],
      respondent_class: nps_payload["respondent_class"],
      object_class: nps_payload["object_class"],
      respondent_id: nps_payload["respondent_id"],
      object_id: nps_payload["object_id"]
    )
    nps.save!
  rescue StandardError => e
    create_log(false, nps_payload, { message: e.message })
  end

  def create_log(success, payload, message = {})
    message = { success:, payload: }.merge(message).to_json
    severity = success ? :info : :error
    Rails.logger.send(severity, message)
  end
end
