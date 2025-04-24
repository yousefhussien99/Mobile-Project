from django.urls import path
from .views import get_all_stores, get_store_by_id, create_store, update_store, delete_store
urlpatterns = [
    path('stores/', get_all_stores, name='get_all_stores'),
    path('stores/<int:store_id>/', get_store_by_id, name='get_store_by_id'),
    path('stores/create/', create_store, name='create_store'),
    path('stores/update/<int:store_id>/', update_store, name='update_store'),
    path('stores/delete/<int:store_id>/', delete_store, name='delete_store'),
]