# /home/nemo/python/lib/python3.6/site-packages/NEMO/views/
# settings.py: AUTHENTICATION_BACKENDS = ['NEMO.views.fake_authentication.AllowAnyPasswordBackend']

from django.contrib.auth import get_user_model
from pprint import pprint

class AllowAnyPasswordBackend:

    def authenticate(self, username=None, password=None):
        User = get_user_model()
        try:
            return User.objects.get(username=username)
        except User.DoesNotExist:
            return None

    def get_user(self, user_id):
        User = get_user_model()
        try:
            return User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return None
