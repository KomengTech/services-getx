# Getting Started

An app for managing **Services** such as **GetConnect**, **Firebase** and **AppWrite** using GetX to support the development process with a **Authentication Flow UI Design**. 

The app use abstract class to ensure that all the services have the same function calls. 

It is a good practice for splitting codes so that you can test on development while still having a stable production, or if you are planning to port over a new service into the app.

## Setup
Create an **Abstract Class** to manage all the Services function.
<pre lang="javascript"><code>
abstract_services.dart

abstract class AbstractServices {

  void init({required String baseUrl});

}
</code></pre>


Then create the main **Services() Class** where your **Frontend Codes** will call to connect to the different services, and **"implements"** the **AbstractServices Class**.
<pre lang="javascript"><code>
services.dart

class Services implements AbstractServices {
  var abstractServices = TestServices();
  // var abstractServices = GetXServices();
  
  @override
  void init({required String baseUrl}) {
    abstractServices.init(baseUrl: baseUrl);
  }

}
</code></pre>

Next you will create the **Separate Services Class** that will link directly to the actual service, and **"implements"** the **AbstractServices Class**.
<pre lang="javascript"><code>
test_services.dart

class TestServices implements AbstractServices {
  @override
  void init({required String baseUrl}) {
    // TODO: implement init() function
    throw UnimplementedError();
  }

}
</code></pre>

<pre lang="javascript"><code>
getx_services.dart

class GetXServices extends GetConnect implements AbstractServices {
  @override
  void init({required String baseUrl}) {
    // TODO: implement init() function
    throw UnimplementedError();
  }

}
</code></pre>

## Usage:
You can use the services by calling the Main Services class and updating the Abstract Services accordingly.
<pre lang="javascript"><code>
services.dart

var abstractServices = TestServices(); // Use this for Test services
// var abstractServices = GetXServices(); // Or change to this for GetX services
</code></pre>

<pre lang="javascript"><code>
var Services services = Services();

void init() {
  services.init();
}
</code></pre>

## Adding New Service Functions:
When adding a **New Service Function**, always add from the **AbstractServices** class first.
<pre lang="javascript"><code>
abstract_services.dart

abstract class AbstractServices {
  void init({required String baseUrl});

  Future<void> signUpEmail({
    required String name,
    required String email,
    required String password,
  });

  Future<void> loginEmail({required String email, required String password});

  Future<void> getUserDetails();

  Future<void> logout();
}
</code></pre>

These will then create errors in the other classes that **"implemenpts"** the **AbstractServices** class, to prompt you to add the same functions.
<pre lang="javascript"><code>
services.dart

class Services implements AbstractServices {
  var abstractServices = TestServices();
  // var abstractServices = GetXServices();
  
  @override
  void init({required String baseUrl}) {
    abstractServices.init(baseUrl: baseUrl);
  }

  @override
  Future<void> signUpEmail({required String name, required String email, required String password}) async {
    await abstractServices.signUpEmail(name: name, email: email, password: password);
  }

  @override
  Future<void> loginEmail({required String email, required String password}) async {
    await abstractServices.loginEmail(email: email, password: password);
  }

  @override
  Future<void> getUserDetails() async {
    await abstractServices.getUserDetails();
  }

  @override
  Future<void> logout() async {
    await abstractServices.logout();
  }
}
</code></pre>
<pre lang="javascript"><code>
test_services.dart

class TestServices implements AbstractServices {
  @override
  void init({required String baseUrl}) {
    // TODO: implement init() function
    throw UnimplementedError();
  }

  @override
  Future<void> signUpEmail({required String name, required String email, required String password}) async {
    // TODO: Implement signUpEmail() function
    throw UnimplementedError();
  }

  @override
  Future<void> loginEmail({required String email, required String password}) async {
    // TODO: Implement loginEmail() function
    throw UnimplementedError();
  }

  @override
  Future<void> getUserDetails() async {
    // TODO: Implement getUserDetails() function
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout() function
    throw UnimplementedError();
  }
}
</code></pre>
<pre lang="javascript"><code>
getx_services.dart

class GetXServices extends GetConnect implements AbstractServices {
  @override
  void init({required String baseUrl}) {
    // TODO: implement init() function
    throw UnimplementedError();
  }

  @override
  Future<void> signUpEmail({required String name, required String email, required String password}) async {
    // TODO: Implement signUpEmail() function
    throw UnimplementedError();
  }

  @override
  Future<void> loginEmail({required String email, required String password}) async {
    // TODO: Implement loginEmail() function
    throw UnimplementedError();
  }

  @override
  Future<void> getUserDetails() async {
    // TODO: Implement getUserDetails() function
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout() function
    throw UnimplementedError();
  }
}
</code></pre>
