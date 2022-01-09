from django.urls import path
from . import views

urlpatterns = [
    path('complain/',views.damageComplain, name='damage-complain'),
]