from django.db import models
from Store.models import Store

class Product(models.Model):
    name = models.CharField(max_length=100, unique=True)
    description = models.TextField(blank=True)

class  StoreProduct(models.Model):
    store = models.ForeignKey(Store, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=0)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    class Meta:
        unique_together = ('store', 'product')


