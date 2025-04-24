from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .models import Product ,StoreProduct
from Store.models import Store
from .serializers import ProductSerializer ,StoreProductSerializer
from Store.serializers import StoreSerializer


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def product_list(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def product_detail(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = ProductSerializer(product)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def store_product_list(request, store_id):
    products = StoreProduct.objects.filter(store_id=store_id)
    serializer = StoreProductSerializer(products, many=True)
    return Response(serializer.data)
@api_view(['GET'])
@permission_classes([IsAuthenticated])
def store_product_detail(request, product_id):
    try:
        store_product = StoreProduct.objects.get(id=product_id)
    except StoreProduct.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)
    stores = Store.objects.filter(storeproduct__id=product_id)
    store_serializer = StoreSerializer(stores, many=True)
    store_product_serializer = StoreProductSerializer(store_product)
    data = {
        'store_product': store_product_serializer.data,
        'stores': store_serializer.data
    }
    return Response(data)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_product(request):
    serializer = ProductSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_store_product(request):
    serializer = StoreProductSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_product(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = ProductSerializer(product, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_store_product(request, store_product_id):
    try:
        store_product = StoreProduct.objects.get(id=store_product_id)
    except StoreProduct.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = StoreProductSerializer(store_product, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_product(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    product.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_store_product(request, store_product_id):
    try:
        store_product = StoreProduct.objects.get(id=store_product_id)
    except StoreProduct.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    store_product.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)
