RSpec.describe GlobalizedMethod do
  let(:klass) do
    Class.new do
      include GlobalizedMethod

      globalized_method :name

      def name_ru
        'NAME_RU'
      end

      def name_en
        'NAME_EN'
      end
    end
  end

  subject do
    klass.new
  end

  before do
    I18n.available_locales = %i[ru en]
  end

  describe '.global_ln' do
    it 'returns method name in current locale' do
      I18n.with_locale(:en) do
        expect(klass.global_ln(:name)).to eq(:name_en)
      end

      I18n.with_locale(:ru) do
        expect(klass.global_ln(:name)).to eq(:name_ru)
      end
    end
  end

  describe '.global_ls' do
    context 'when code is blank' do
      it 'returns method names in all possible locales' do
        expect(klass.global_ls(:name)).to contain_exactly(:name_en, :name_ru)
      end
    end

    context 'when code is passed' do
      it 'returns method names in all possible locales with locale code' do
        expect(klass.global_ls(:name, code: true)).to contain_exactly(%i[name_en en], %i[name_ru ru])
      end
    end
  end

  describe '#name' do
     it 'returns method result in current locale' do
       I18n.with_locale(:en) do
         expect(subject.name).to eq('NAME_EN')
       end

       I18n.with_locale(:ru) do
         expect(subject.name).to eq('NAME_RU')
       end
     end
  end
end
