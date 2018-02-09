# -------------------- Django settings for NEMO --------------------
# Customize these to suit your needs. Documentation can be found at:
# https://docs.djangoproject.com/en/1.11/ref/settings/

# Core settings

# DANGER: SETTING "DEBUG = True" ON A PRODUCTION SYSTEM IS EXTREMELY DANGEROUS.
# ONLY SET "DEBUG = True" FOR DEVELOPMENT AND TESTING!!!
DEBUG = True
AUTH_USER_MODEL = 'NEMO.User'
WSGI_APPLICATION = 'NEMO.wsgi.application'
ROOT_URLCONF = 'NEMO.urls'
PROJECT_PATH = '/home/nemo'

# Authentication
LOGIN_URL = 'login'
LOGIN_REDIRECT_URL = 'login'

# Date and time formats
DATETIME_FORMAT = "l, F jS, Y @ g:i A"
DATE_FORMAT = "m/d/Y"
TIME_FORMAT = "g:i A"
DATETIME_INPUT_FORMATS = ['%m/%d/%Y %I:%M %p']
DATE_INPUT_FORMATS = ['%m/%d/%Y']
TIME_INPUT_FORMATS = ['%I:%M %p']

USE_I18N = False
USE_L10N = False
USE_TZ = True

INSTALLED_APPS = [
	'django.contrib.auth',
	'django.contrib.contenttypes',
	'django.contrib.sessions',
	'django.contrib.messages',
	'django.contrib.staticfiles',
	'django.contrib.admin',
	'django.contrib.humanize',
	'NEMO',
	'rest_framework',
	'django_filters',
]

MIDDLEWARE = [
	'django.middleware.security.SecurityMiddleware',
	'django.middleware.common.CommonMiddleware',
	'django.contrib.sessions.middleware.SessionMiddleware',
	'django.middleware.csrf.CsrfViewMiddleware',
	'django.contrib.auth.middleware.AuthenticationMiddleware',
	'django.contrib.auth.middleware.RemoteUserMiddleware',
	'django.contrib.messages.middleware.MessageMiddleware',
	'django.middleware.clickjacking.XFrameOptionsMiddleware',
	'django.middleware.common.BrokenLinkEmailsMiddleware',
	'NEMO.middleware.DeviceDetectionMiddleware',
]

TEMPLATES = [
	{
		'BACKEND': 'django.template.backends.django.DjangoTemplates',
		'APP_DIRS': True,
		'OPTIONS': {
			'context_processors': [
				'NEMO.context_processors.hide_logout_button',  # Add a 'request context processor' in order to figure out whether to display the logout button. If the site is configured to use the LDAP authentication backend then we want to provide a logoff button (in the menu bar). Otherwise the Kerberos authentication backend is used and no logoff button is necessary.
				'NEMO.context_processors.device',  # Informs the templating engine whether the template is being rendered for a desktop or mobile device.
				'django.contrib.auth.context_processors.auth',
				'django.template.context_processors.debug',
				'django.template.context_processors.media',
				'django.template.context_processors.static',
				'django.template.context_processors.tz',
				'django.contrib.messages.context_processors.messages',
			],
		},
	},
]


def get_file_contents(path):
	with open(path) as f:
		return f.read().strip()

EMAIL_BACKEND = 'django.core.mail.backends.filebased.EmailBackend'
EMAIL_FILE_PATH = PROJECT_PATH + '/email'

TIME_ZONE = 'America/New_York'

DATABASES = {
	'default': {
		'ENGINE': 'django.db.backends.sqlite3',
		'NAME': PROJECT_PATH + '/sqlite.db',
	}
}

STATIC_ROOT = PROJECT_PATH + '/static'
STATIC_URL = '/static/'
MEDIA_ROOT = PROJECT_PATH + '/media'
MEDIA_URL = '/media/'

# Make this unique, and don't share it with anybody.
SECRET_KEY = get_file_contents(PROJECT_PATH + '/secrets/django_secret_key.txt')

# -------------------- Third party Django addons for NEMO --------------------
# These are third party capabilities that NEMO employs. They are documented on
# the respective project sites. Only customize these if you know what you're doing.

# Django REST framework:
# http://www.django-rest-framework.org/
REST_FRAMEWORK = {
	'DEFAULT_PERMISSION_CLASSES': ('NEMO.permissions.BillingAPI',),
	'DEFAULT_FILTER_BACKENDS': ('django_filters.rest_framework.DjangoFilterBackend',),
	'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
	'PAGE_SIZE': 1000,
}

# ------------ Organization specific settings (NEMO specific; NOT supported by Django) ------------
# Customize these to suit your needs

# When true, all available URLs and NEMO functionality is enabled.
# When false, conditional URLs are removed to reduce the attack surface of NEMO.
# Reduced functionality for NEMO is desirable for the public facing version
# of the site in order to mitigate security risks.
ALLOW_CONDITIONAL_URLS = True

# There are two options to authenticate users:
#   1) A decoupled "REMOTE_USER" method (such as Kerberos authentication from a reverse proxy)
#   2) LDAP authentication from NEMO itself
AUTHENTICATION_BACKENDS = ['NEMO.views.fake_authentication.AllowAnyPasswordBackend']

# Specify your list of LDAP authentication servers only if you choose to use LDAP authentication.
# If you are not using LDAP then set this to be an empty list [].
LDAP_SERVERS = [
	{
		'url': 'ldap.another.org',
		'domain': 'ANOTHER',
		'certificate': PROJECT_PATH + '/secrets/root.crt',
	},
	{
		'url': 'ldap.example.org',
		'domain': 'EXAMPLE',
		'certificate': PROJECT_PATH + '/secrets/root.crt',
	},
]

# NEMO can integrate with a custom Identity Service to manage user accounts on
# related computer systems, which streamlines user onboarding and offboarding.
IDENTITY_SERVICE = {
	'available': False,
	'url': 'https://identity.example.org/',
	'domains': ['ANOTHER', 'EXAMPLE'],
}