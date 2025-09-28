from rest_framework import serializers
from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from account_api.models import CustomUser


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only = True, min_length = 8)
    
    class Meta:
        model = CustomUser
        fields = ('id', 'first_name', 'last_name' 'username', 'email', 'number', 'age', 'password')
        
        def validate_email(self, value):
            if CustomUser.objects.filter(email = value).exists():
                raise serializers.ValidationError("Email already exists")   
            return value
        
        def validate_number(self, value):
            if CustomUser.objects.filter(number = value).exists():
                raise serializers.ValidationError("Number already exists")   
            return value
        
        def create(self, validated_data):
            user = CustomUser.objects.create_user(
                first_name = validated_data['first_name'],
                last_name = validated_data['last_name'],
                username = validated_data['username'],
                email = validated_data['email'],
                number = validated_data['number'],
                age = validated_data['age'],
                password = validated_data['password']
            )
            return user
        
        
class LoginSerializer(serializers.Serializer):
    identifier = serializers.CharField()
    password = serializers.CharField(write_only = True)
    
    def validate(self, data):
        identifier = data.get('identifier')
        password = data.get('password')

        user_obj = None
        user_qs = CustomUser.objects.filter(email__iexact=identifier)
        if user_qs.exists():
            user_obj = user_qs.first()
            username = user_obj.username
        else:
            username = identifier

        user = authenticate(username=username, password=password)
        if not user:
            raise serializers.ValidationError("Identifiant invalide.")
        data['user'] = user
        return data
    

