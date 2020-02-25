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

  describe '#name with fallbacks hash' do
    context 'when fallbacks empty' do
      let(:klass) do
        Class.new do
          include GlobalizedMethod

          globalized_method :name

          def name_ru
            nil
          end

          def name_en
            'NAME_EN'
          end
        end
      end

      it 'returns nil' do
        I18n.with_locale(:ru) do
          expect(subject.name).to eq(nil)
        end
      end
    end

    context 'when fallbacks exists' do
      let(:klass) do
        Class.new do
          include GlobalizedMethod

          globalized_method :name, fallbacks: { ru: %i[en] }

          def name_ru
            nil
          end

          def name_en
            'NAME_EN'
          end
        end
      end

      it 'returns fallback' do
        I18n.with_locale(:ru) do
          expect(subject.name).to eq('NAME_EN')
        end
      end
    end
  end

  describe '#name with fallbacks in a block' do
    let(:klass) do
      Class.new do
        include GlobalizedMethod

        globalized_method :name, fallbacks: ->(model) do
          model.name_int
        end

        def name_ru
          nil
        end

        def name_en
          'NAME_EN'
        end

        def name_int
          'NAME_INT'
        end
      end
    end

    it 'works' do
      I18n.with_locale(:ru) do
        expect(subject.name).to eq('NAME_INT')
      end

      I18n.with_locale(:en) do
        expect(subject.name).to eq('NAME_EN')
      end
    end
  end
end
