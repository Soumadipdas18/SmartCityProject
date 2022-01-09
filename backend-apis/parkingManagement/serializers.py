from rest_framework import serializers
from .models import CarToBeParked, ParkingLot


class ParkingLotSerializer(serializers.ModelSerializer):
    adminPhone = serializers.CharField(max_length=10)
    latitude = serializers.CharField(max_length=200)
    longitude = serializers.CharField(max_length=200)
    totalSlots = serializers.IntegerField(default=0)
    emptySlots = serializers.IntegerField(default=0)

    class Meta:
        model = ParkingLot
        fields = ['adminPhone','latitude','longitude','totalSlots','emptySlots']


class CarToBeParkedSerializer(serializers.ModelSerializer):
    parkingLotAdminId = serializers.CharField(max_length=100)
    class Meta:
        model = CarToBeParked
        fields = ['parkingLotAdminId','startTime','endTime']

class VerifyAccessIdSerializer(serializers.ModelSerializer):
    accessId = serializers.CharField(max_length=100)
    class Meta:
        model = CarToBeParked
        fields = ['accessId']

class ParkingAvailabilitySerializer(serializers.ModelSerializer):
    parkingLotAdminId = serializers.CharField(max_length=100)
    class Meta:
        model = ParkingLot
        fields = ['parkingLotAdminId']