from rest_framework import serializers
from .models import RoadComplains

class RoadComplainSerializer(serializers.ModelSerializer):

    latitude = serializers.CharField(max_length=200)
    longitude = serializers.CharField(max_length=200)
    image = serializers.ImageField() 
