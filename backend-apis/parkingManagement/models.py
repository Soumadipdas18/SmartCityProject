from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class ParkingLot(models.Model):
    user = models.ForeignKey(User,on_delete=models.CASCADE)
    adminPhone = models.CharField(max_length=10)
    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    totalSlots = models.IntegerField(default=0)

    def __str__(self):
        return f'{self.user}'



class CarToBeParked(models.Model):
    parkingLot = models.ForeignKey(ParkingLot,on_delete=models.CASCADE)
    accessId = models.CharField(max_length=100)
    startTime = models.DateTimeField()
    endTime = models.DateTimeField()

    def __str__(self):
        return self.accessId