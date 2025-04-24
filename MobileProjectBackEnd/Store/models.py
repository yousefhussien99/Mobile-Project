from django.db import models
STORE_TYPES = [
    ('restaurant', 'Restaurant'),
    ('cafe', 'Cafe'),
]
class Store(models.Model):
    name = models.CharField(max_length=100)
    type = models.CharField(max_length=50, choices=STORE_TYPES)
    location = models.CharField(max_length=255)
    latitude = models.FloatField()
    longitude = models.FloatField()

    def __str__(self):
        return self.name
