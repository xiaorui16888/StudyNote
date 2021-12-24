# Django 解决跨域

1、先安装模块

```
pip install django-cors-headers
```

2、然后在Django的setting.py中进行相关设置即可

在INSTALLED_APPS中添加

```
INSTALLED_APPS = [
     .......
   
    'corsheaders',
]
```

3、配置中间件

```
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',                  # 注意顺序
    'django.middleware.common.CommonMiddleware',
    # 'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]
```

4、允许的头

```
CORS_ALLOW_CREDENTIALS = True  # 允许携带cookie
CORS_ORIGIN_ALLOW_ALL = True#################################
CORS_ALLOW_METHODS = (    'DELETE',    'GET',    'OPTIONS',    'PATCH',    'POST',    'PUT',    'VIEW',)

CORS_ALLOW_HEADERS = (    'XMLHttpRequest',    'X_FILENAME',    'accept-encoding',    'authorization',    'content-type',    'dnt',    'origin',    'user-agent',    'x-csrftoken',    'x-requested-with',    'Pragma',)
```

就这样，很容易的解决了跨域的问题。

记得重启哦~

