from django.shortcuts import render
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import serializers, status
import uuid
from .models import RoadComplains
from .serializers import RoadComplainSerializer
from . import DeepLearningModel
from PIL import Image
import os
from pathlib import Path
import matplotlib
import matplotlib.pyplot as plt


# Create your views here.

dirpath = os.path.dirname(os.path.abspath(__file__))
image_folder = os.path.join(dirpath,'images')
baseDir = str(Path.cwd())
# baseDir = str(Path(baseDir).parents[0])
baseDir = baseDir.replace("\\",'/')

@api_view(['POST'])
def damageComplain(request):
    if request.method=='POST':
        latitude = request.data['latitude']
        longitude = request.data['longitude']
        image = request.FILES['image']
        model = RoadComplains(latitude=latitude,longitude=longitude,image=image)
        model.save()
        image_location = model.image.url
        print('000000000000000000000000000000000000000000000')
        print(image_location)
        print(image_folder)
        print(baseDir)
        image_location = baseDir+image_location
        print('xoxox')
        print(image_location)
        image_np,*_ = DeepLearningModel.detect(image_location)
        im = Image.fromarray(image_np)
        location = str(uuid.uuid4())+'.jpeg'
        location = os.path.join(image_folder,location)
        print(location)
        # matplotlib.image.imsave(location, image_np)
        im.save(location)
        # plt.imshow(image_np) #Needs to be in row,col order
        # plt.savefig(image_folder)
        model.imageLocation = location
        model.save()
        return Response(status=status.HTTP_200_OK)
        
