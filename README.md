# Stimpack

`stimpack` makes integrating with [`packwerk`](https://github.com/Shopify/packwerk) easy and establishes conventions such that packwerk packages mimic the feel and structure of [Rails engines](https://guides.rubyonrails.org/engines.html), without all of the boilerplate. With `stimpack`, new packages' autoload paths are automatically added to Rails, so your code will immediately become usable and loadable without additional configuration.

Here is an example application that uses `stimpack`:
```
package.yml # root level pack
app/ # Unpackaged code
  models/
  ...
packs/ # This is not yet configurable, but we're working on it!
  my_domain/
    package.yml # See the packwerk docs for more info
    deprecated_references.yml # See the packwerk docs for more info
    app/
      public/ # Recommended location for public API
        my_domain.rb # creates the primary namespaces
        my_domain/
          my_subdomain.rb
      services/ # Private services
        my_domain/
          some_private_class.rb
      models/ # Private models
        some_other_non_namespaced_private_model.rb # this works too
        my_domain/
          my_private_namespacd_model.rb
      config/
        initializers/ # Initializers can live in packs and load as expected
      controllers/
      views/
      lib/
        tasks/
    spec/ # With stimpack, specs for a pack live next to the pack
      public/
        my_domain_spec.rb
        my_domain/
          my_subdomain_spec.rb
      services/
        my_domain/
          some_private_class_spec.rb
      models/
        some_other_non_namespaced_private_model_spec.rb
        my_domain/
          my_private_namespaced_model_spec.rb
      factories/ # Stimpack will automatically load pack factories into FactoryBot
        my_domain/
          my_private_namespaced_model_factory.rb
  my_other_domain/
    ... # other pack's have a similar structure
  my_other_other_domain/
    ...
```

## Usage

Setting up `stimpack` is straightforward. Simply by including `stimpack` in your `Gemfile` in all environments, `stimpack` will automatically hook into and configure Rails.

From there, you can create a `./packs` folder and structure it using the conventions listed above.

If you wish to use a different directory name, eg `components` instead of `packs`, you can customize this in your `config/application.rb` file:

```ruby
# Customize Stimpack's root directory. Note that this has to be done _before_ the Application
# class is declared.
Stimpack.config.root = "components"

module MyCoolApp
  class Application < Rails::Application
    # ...
  end
end
```

### Making your Package an Engine
Add `engine: true` to your `package.yml` to make it an actual Rails engine:
```yml
# packs/my_pack/package.yml
enforce_dependencies: true
enforce_privacy: true
metadata:
  engine: true
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Gusto/stimpack.
