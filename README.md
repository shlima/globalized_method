# GlobalizedMethod

Usage example

```bash
gem install globalized_method
```

```ruby
class Item < ApplicationRecord # or BasicObject (works the same)
  include GlobalizedMethod
  
  globalized_method :name
  
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
