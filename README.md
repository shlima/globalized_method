# GlobalizedMethod

Usage example

```bash
gem install globalized_method
```

```ruby
# set fallbacks globally
GlobalizedMethod.fallbacks[:ru] = %i[en]
```

```ruby
class Item < ApplicationRecord # or BasicObject (works the same)
  include GlobalizedMethod
  
  # 1)
  globalized_method :name, fallbacks: { ru: %i[en] }
  
  # 2)
  globalized_method :name, fallbacks: ->(record) do
    record.name_international 
  end
  
  def name_en
    'some name'
  end
  
  def name_ru
    'некоторое имя'
  end
end
```

```ruby
I18n.with_locale(:en) do
  Item.global_ln(:name) #=> :name_en
end

I18n.with_locale(:ru) do
  Item.global_ln(:name) #=> :name_ru
end
```
```ruby
Item.global_ls(:name) #=> [:name_en, :name_ru]
Item.global_ls(:name, code: true) #=> [[:name_en, :en], [:name_ru, :ru]]
```
```ruby
I18n.with_locale(:en) do
  Item.new.name #=> 'some name'
end

I18n.with_locale(:ru) do
  Item.new.name #=> 'некоторое имя'
end
```
