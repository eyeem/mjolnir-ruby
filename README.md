[![Build Status](https://travis-ci.org/eyeem/mjolnir-ruby.png)](https://travis-ci.org/eyeem/mjolnir-ruby)

mjolnir-ruby
============

Mjolnir is a java code generation tool written in ruby that aims to replace things like jackson/gson with a generated native code.

Installation
============

```
gem build mjolnir.gemspec && sudo gem install ./mjolnir-0.1.0.gem
```

Working with mjolnir
============

Let's say we have an API endpoint like this

```
curl "https://api.eyeem.com/v2/users/ramz?client_id=XwOELOXpiSI0aFJjOwJMyy9fcjSsLx6i"
```
with the following output
```json
{
    "user": {
        "description": "Mobile dev & unicorn operator at EyeEm. Contact me on twitter.com/vishna or via mail: lukasz@eyeem.com.",
        "fullname": "\u0141ukasz Wi\u015bniewski",
        "id": "188307",
        "nickname": "vishna",
        "photoUrl": "http://www.eyeem.com/thumb/sq/200/6394e23710b9574829236924fa66bafc2322b614-1379166045",
        "thumbUrl": "http://www.eyeem.com/thumb/sq/50/6394e23710b9574829236924fa66bafc2322b614-1379166045",
        "totalFollowers": 677,
        "totalFriends": 366,
        "totalLikedAlbums": 30,
        "totalLikedPhotos": 2471,
        "totalPhotos": 884,
        "webUrl": "http://www.eyeem.com/u/vishna"
    }
}

```
Based on that output we can create a mjolnir `yaml` sketch:
```
 curl "https://api.eyeem.com/v2/users/vishna?client_id=XwOELOXpiSI0aFJjOwJMyy9fcjSsLx6i" | mjolnir-sketch > user.yaml
```
So you get something like:
```yaml
---
user:
  description: String
  fullname: String
  id: String
  nickname: String
  photoUrl: String
  thumbUrl: String
  totalFollowers: Fixnum
  totalFriends: Fixnum
  totalLikedAlbums: Fixnum
  totalLikedPhotos: Fixnum
  totalPhotos: Fixnum
  webUrl: String

```
Now all you need to do is generate `java` files, to do so simply:
```
mjolnir-package --yaml user.yaml --package com.eyeem.sdk --output destDir
```
...ane here goes `destDir/com/eyeem/sdk/User.java` TADA!
```java
// generated file, do not edit!

package com.eyeem.sdk;

import java.io.Serializable;
import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONObject;



public final class User implements Serializable {
   // serializable
   private static final long serialVersionUID = -2800020519567815353L;

   // members

   public String description;

   public String fullname;

   public String id;

   public String nickname;

   public String photoUrl;

   public String thumbUrl;

   public long totalFollowers;

   public long totalFriends;

   public long totalLikedAlbums;

   public long totalLikedPhotos;

   public long totalPhotos;

   public String webUrl;


   // ctor
   public User() {
      // default
   }

   public User(JSONObject json) {
      
         description = json.optString("description", "");
      
         fullname = json.optString("fullname", "");
      
         id = json.optString("id", "");
      
         nickname = json.optString("nickname", "");
      
         photoUrl = json.optString("photoUrl", "");
      
         thumbUrl = json.optString("thumbUrl", "");
      
         totalFollowers = json.optLong("totalFollowers", 0);
      
         totalFriends = json.optLong("totalFriends", 0);
      
         totalLikedAlbums = json.optLong("totalLikedAlbums", 0);
      
         totalLikedPhotos = json.optLong("totalLikedPhotos", 0);
      
         totalPhotos = json.optLong("totalPhotos", 0);
      
         webUrl = json.optString("webUrl", "");
      
      
   }



   // static methods
   public static ArrayList<User> fromJSONArray(JSONArray array) {
      ArrayList<User> result = new ArrayList<User>();
      if (array == null || array.length() < 1)
         return result;

      int n = array.length();
      for (int i=0; i<n; i++) {
         JSONObject obj = array.optJSONObject(i);
         if (null != obj) {
            result.add(new User(obj));
         }
      }
      return result;
   }
}
```

Integrating with Android gradle
===============================

```groovy
task generateSources {
    doFirst {
        println "Mjolnir source code generation"
        exec { // purge old classes
            commandLine 'rm', '-rf', 'src/mjolnir-java'
        }
        exec { // generate new ones
            commandLine 'mjolnir-package', '--yaml', 'path/to/your/yaml/model.yaml', '--packagename', 'com.yourpackage.sdk', '--output', 'src/mjolnir-java'
        }
    }
}

gradle.projectsEvaluated {
    compileDebug.dependsOn(generateSources)
}

android {
    // bla bla some stuff ...

    // include generated sources
    sourceSets {
        main {
            java {
                srcDirs 'src/mjolnir-java'
            }
        }
    }
}
```

Mixins
======

If you'd like to extend functionality of your generated classes you can modify `yaml` sketch and provide some extra code, here is how you can do it:

```yaml
user:
  id: String
  nickname: String
  fullname: String
  webUrl: String
  thumbUrl: String
  photoUrl: String
  description: String
  import_linkify:
    ImportMixin: android.util.Log
  init_entities:
    CtorMixin: > Log.i("User", "WOW. I'm in a constructor. WOW.");
  entities:
    Mixin: |
      private static final String MY_KEY = "mySecr3tKey";
```

Developed By
============

* Lukasz Wisniewski [@vishna](https://twitter.com/vishna)

Inspirations
============

* Max Howell [@mxcl](https://twitter.com/mxcl) and his work on yaml-java generator back in TweetDeck days.

License
=======

    Copyright 2013 EyeEm Mobile GmbH

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.