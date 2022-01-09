from django.contrib import admin
from .models import ParkingLot, CarToBeParked

# Register your models here.
admin.site.register(ParkingLot)
admin.site.register(CarToBeParked)