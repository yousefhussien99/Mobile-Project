from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from .models import Store
from .serializers import StoreSerializer

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_all_stores(request):
    stores = Store.objects.all()
    serializer = StoreSerializer(stores, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_store_by_id(request, store_id):
    try:
        store = Store.objects.get(id=store_id)
        serializer = StoreSerializer(store)
        return Response(serializer.data)
    except Store.DoesNotExist:
        return Response({"error": "Store not found"}, status=404)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_store(request):
    serializer = StoreSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=201)
    return Response(serializer.errors, status=400)

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_store(request, store_id):
    try:
        store = Store.objects.get(id=store_id)
        serializer = StoreSerializer(store, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)
    except Store.DoesNotExist:
        return Response({"error": "Store not found"}, status=404)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_store(request, store_id):
    try:
        store = Store.objects.get(id=store_id)
        store.delete()
        return Response(status=204)
    except Store.DoesNotExist:
        return Response({"error": "Store not found"}, status=404)
