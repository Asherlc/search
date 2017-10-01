require_relative '../lib/search/input_validation'

RSpec.describe InputValidation do
  describe '.validate_data_source' do
    context 'with an invalid data source' do
      it 'throws an error' do
        expect { InputValidation.validate_data_source('costanzas') }.to raise_error(InputError)
      end
    end

    context 'with a valid data source' do
      it 'does not throw an error' do
        expect { InputValidation.validate_data_source('organizations') }.to_not raise_error
      end
    end
  end

  describe '.validate_attribute_value' do
    context 'with an invalid attribute value pair' do
      it 'throws an error' do
        expect { InputValidation.validate_attribute_value('jerry') }.to raise_error(InputError)
      end
    end

    context 'with a valid attribute value pair' do
      it 'does not throw an error' do
        expect { InputValidation.validate_attribute_value('neighbors:jerry') }.to_not raise_error
      end
    end
  end
end