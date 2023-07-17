from rest_framework import serializers
from general.models import  Objects

class ObjectsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Objects
        fields = ('name', 'level')