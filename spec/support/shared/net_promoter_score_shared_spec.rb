# frozen_string_literal: true

require 'rails_helper'

RSpec.shared_examples 'a net promoter score' do
  context 'validations' do
    it 'validates uniqueness of respondent_id in scope of respondent_class' do
      subject.respondent_id = 1
      subject.save
      dupped_subject = subject.dup

      expect(dupped_subject).not_to be_valid
      expect(dupped_subject.errors.messages[:respondent_id].first).to eq('has already been taken')

      dupped_subject.respondent_class = 'Test'
      dupped_subject.object_class = 'Test'
      expect(dupped_subject.save(validate: false)).to be_truthy
      expect(dupped_subject.persisted?).to be_truthy
    end

    it 'validates uniqueness of object_id in scope of object_class' do
      subject.object_id = 1
      subject.save
      dupped_subject = subject.dup

      expect(dupped_subject).not_to be_valid
      expect(dupped_subject.errors.messages[:object_id].first).to eq('has already been taken')

      dupped_subject.object_class = 'Test'
      dupped_subject.respondent_class = 'Test'
      expect(dupped_subject.save(validate: false)).to be_truthy
      expect(dupped_subject.persisted?).to be_truthy
    end
  end
end
