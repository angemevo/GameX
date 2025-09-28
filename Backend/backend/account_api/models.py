from django.db import models
from django.contrib.auth.models import AbstractUser


# Create your models here.
class CustomUser(AbstractUser):
    first_name = models.CharField(max_length=30, blank=True)
    last_name = models.CharField(max_length=30, blank=True)
    email = models.EmailField(max_length=120, unique=True)
    number = models.CharField(max_length=15, unique=True)
    age = models.PositiveIntegerField(null=True, blank=True)
    
    def __str__(self):
        return self.username