from django.db import models

# Create your models here.
class RoadComplains(models.Model):

    latitude = models.CharField(max_length=200)
    longitude = models.CharField(max_length=200)
    imageLocation = models.CharField(max_length=200,blank=True)
    image = models.ImageField(upload_to='recieved',blank=True,null=True)
    score = models.CharField(max_length=200,blank=True)

    def __str__(self):
        return f'{self.image}'