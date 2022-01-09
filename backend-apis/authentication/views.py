from django.shortcuts import render
from .serializers import UserSerializer
from rest_framework.response import Response
import uuid
from rest_framework import status
from django.contrib.auth.models import User
from rest_framework.generics import GenericAPIView

# Create your views here.
class RegisterView(GenericAPIView):
    serializer_class = UserSerializer
    def post(self,request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            user=User.objects.filter(username=request.data['username']).first()
            auth_token = str(uuid.uuid4())
            print(user,auth_token)
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
