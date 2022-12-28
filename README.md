# Stimpack

`stimpack` establishes and implements a set of conventions for splitting up large monoliths built on top of [`packwerk`](https://github.com/Shopify/packwerk). With `stimpack`, new packages' autoload paths are automatically added to Rails, so your code will immediately become usable and loadable without additional configuration.

Here is an example application that uses `stimpack`:
```
package.yml # root level pack
app/ # Unpackaged code
  models/
  ...
packs/
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
      controllers/
      views/
    config/
      initializers/ # Initializers can live in packs and load as expected
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
    ... # other packs have a similar structure
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

### Splitting routes
`stimpack` allows you to split your application routes for every pack. You just have to create a file describing your routes and then `draw` them in your root `config/routes.rb` file.

```ruby
# packs/my_domain/config/routes/my_domain.rb
resources :my_resource

# config/routes.rb
draw(:my_domain)
```

### Making your Package an Engine
Add `engine: true` to your `package.yml` to make it an actual Rails engine ([read more about what this means here](https://guides.rubyonrails.org/engines.html)):
```yml
# packs/my_pack/package.yml
enforce_dependencies: true
enforce_privacy: true
metadata:
  engine: true
```

## Ecosystem and Integrations

### RSpec Integration
Simply add `--require stimpack/rspec` to your `.rspec`.
Or, if you'd like, pass it as an argument to `rspec`:

```
$ rspec --require stimpack/rspec ...
```

Integration will allow you to run tests as such:
```
# Run all specs in your entire application (packs and all):
rspec

# Run just that one test:
rspec spec/some/specific_spec.rb

# Run all tests under the "foobar" pack and all the tests of its nested packs:
rspec packs/foobar

# Same as above but also adds the "binbaz" pack:
rspec packs/foobar pack/binbaz

# Run all test files inside the "packs/foobar/spec" directory:
rspec packs/foobar/spec

# Run all specs under the "packs/foobar/nested_pack" pack:
rspec packs/foobar/nested_pack
```

#### parallel_tests

`parallel_tests` has it its own spec discovery mechanism, so Stimpack's RSpec integration doesn't do anything when you use them together.
To make them work, you'll need to explicitly specify the spec paths:

```bash
RAILS_ENV=test bundle exec parallel_test spec packs/**/spec -t rspec <other_options>
```

#### Knapsack (Pro)

Similarly, Knapsack (and its Pro version) has its own spec discovery mechanism and the API will find and queue the relevant specs.
To make it discover your pack tests as well, you'll need to configure the following variables:

```yaml
KNAPSACK_PRO_TEST_DIR: spec
KNAPSACK_PRO_TEST_FILE_PATTERN: '{spec,packs}/**{,/*/**}/*_spec.rb'
```

Setting `KNAPSACK_PRO_TEST_FILE_PATTERN` will tell Knapsack where your specs are located, while setting `KNAPSACK_PRO_TEST_DIR` is necessary because otherwise an incorrect value is sent to rspec via the `--default-path` option.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Gusto/stimpack.
