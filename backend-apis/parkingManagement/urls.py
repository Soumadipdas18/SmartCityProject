from django.urls import path
from . import views

urlpatterns = [
    path('register/lot/',views.registerParkingLot, name='register-lot'),
    path('register/car/',views.registerCarToBeParked, name='register-car'),
    path('availability/',views.parkingAvailability, name='parking-availability'),
    path('verify/',views.verifyAccessId, name='verify-access-id'),
]