from django.contrib.auth.models import AbstractUser
from django.db import models
LEVEL_CHOICES = (
    (1, "Level 1"),
    (2, "Level 2"),
    (3, "Level 3"),
    (4, "Level 4"),
)
GENDER_CHOICES =[('male', 'Male'), ('female', 'Female')]
class CustomUser(AbstractUser):
    gender = models.CharField(max_length=10, blank=True, null=True, choices=GENDER_CHOICES )
    level = models.IntegerField(choices=LEVEL_CHOICES, null=True, blank=True)
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, unique=False)
    password = models.CharField(max_length=128)
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'password']

