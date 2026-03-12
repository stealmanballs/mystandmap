# frozen_string_literal: true

# Assuming you have not yet modified this file, you can uncomment some of the options below

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render useless all the existing
  # confirmations, openids and user authentications.
  # config.secret_key = 'your-secret-key'

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" signature.
  # config.mailer_sender = 'noreply@yourdomain.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Devise::Mailer'

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = 'ActionMailer::Base'

  # ==> ORM configuration
  # Load and configure the ORM. Load with :active_record for Rails.

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. In order to add new keys to the method, just add
  # config.authentication_keys = [:email]

  # Configure parameters from the request object used for authentication. Each
  # key given in the configuration represents a method name on the authentication
  # module. config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # for authentication or account update.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used for authentication or account update.
  config.strip_whitespace_keys = [:email]

  # Tell if authentication through request.params is enabled. True by default.
  # It can be set to an array that will enable params authentication only for the
  # given strategies, for example, `config.params_authenticatable = [:database]` will
  # enable it only for database (email + password) authentication.
  # config.params_authenticatable = true

  # Tell if authentication through HTTP Auth is enabled. False by default.
  # It can be set to an array which will enable http authentication only for the
  # given strategies, for example, `config.http_authenticatable = [:database]` will
  # enable it only for database authentication after upgrading to Rails 5.
  # For Rails versions below 5.2, the default is true.
  # config.http_authenticatable = false

  # If 401 status code should be returned for AJAX requests. True by default.
  # config.http_authenticatable_on_xhr = true

  # The realm used in Http Basic Authentication. 'Application' by default.
  # config.http_authentication_realm = 'Application'

  # It will change confirmation, password recovery and other workflows
  # to behave the same regardless if the e-mail provided was right or wrong.
  # config.case_insensitive_keys = [:email]

  # This will change their strategies during the authentication:
  # For example, it changes how user authenticate both via stack:
  # devise :database_authenticatable, :validatable
  # means the password needs to be hashed. No other strategies will use
  # devise :database_authenticatable, :validatable
  # If you don't specify it, when using a username, it has to be unique.
  # By default, Devise doesn't do it. Set it to your unique attribute.
  # config.email_regex = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :validatable
  # Range for password length. Default is 6..128.
  # config.password_length = 6..128

  # Email regex used to validate email formats. It simply asserts that
  # one (and only one) @ exists in the given string. This is mainly
  # to give user feedback and not to assert the e-mail validity.
  # config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again. Default is 30 minutes.
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account
  # when :failed_attempts is reached. Default is :none.
  # config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  # config.unlock_keys = [:email]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time (see :unlock_in below)
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should make sure the account has a valid token for user
  # config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is :failed_attempts.
  # config.maximum_attempts = 20

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  # config.unlock_in = 1.hour

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering 'sessions/new', it will look for a
  # 'sessions' path. If you aren't using :default scope, you can set this to false.
  # config.scoped_views = false

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational. Formats like
  # :html, should add a "navigational" formats to the list:
  # config.navigational_formats = ['*/*', :html, :turbo_stream]
  # The default is [:html]
  config.navigational_formats = ['*/*', :html, :turbo_stream]

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on adding
  # providers to your app.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # you want to overwrite default warden options, you can do that here.
  # Note that you can overwrite the application name which will be used by Warden.
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end
end
