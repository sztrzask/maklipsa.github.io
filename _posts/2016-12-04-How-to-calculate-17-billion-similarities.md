---
layout: post
title: How to calculate 17 billion similarities
description: "How to calculate similarity between two objects? Worst yet how to calculate 17 billion of them?"
modified: 2016-11-28
tags: [.NET, cookit, performance, math]
image:
  feature: data/2016-11-28-How-to-calculate-17-billion-similarities/logo.jpg
---
## Complexity

Before I fire it up let's calculate just how much data am I talking about. I will nead to create for each recipe (182 184 as of the time of writing) a 2936 dimentional vector (the number of ingredients). This gives me 534 892 224 floats. If we do a simple calculation: 

```
534 892 224 * 4(the size of float) ~ 2.14 Gig counting only the floats
```

And if I will want to calculate the similarities I will have to do:

```
((182 184 * 2 936)^2) /2 = 143 054 845 647 833 100 floating point multiplications
```

So citing [Mark Watney](https://en.wikipedia.org/wiki/The_Martian_(Weir_novel)) I will have to science the sh** out of it :)

## Calculating similarity

Our goal is to express how similar two recipes are, and then compare that result to a third recipe and say which one is better. So we have to convert those two vectors into a single digit. Luckily math has figured this long time ago:) There are many algorithms that can be healpful, but the most common, and a good start is the [dot product](https://en.wikipedia.org/wiki/Dot_product):
 
![](data/2016-11-28-How-to-calculate-17-billion-similarities/dot_product.gif)

To explain how it works lets assume that our vectors are two dimensional (so having only two ingredients). Then we can draw them like this (image taken from Wikipedia):

![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Dot_Product.svg/220px-Dot_Product.svg.png)

So what it does is projects one vector onto another (the cosinus part takes care of it). This gives us a relative value which is no use in the longer run (we can't compare to relative values). We have to convert it into an absolute value, preferably in the 0 to 1 range. This is simple. Just divide the shorter length by the longer one.  
Putting all of it into C#:

```csharp
public float Similarity(Vector a, Vector b){    
    float accumulator=0;
    for (int i = 0; i < a.Length; i++)
    {
        accumulator += b[i]*a[i];
    }
    var denom = Length(a)*Length(b); //convertion to absolute 
    return accumulator/denom;         //convertion to absolute    
}    
```

where `Length` looks like this:
```
public float Length(Vector a){    
    return (float)Math.Sqrt(a.Sum(value => value*value));
}
```

Ok, so we know how. So the rest will be easy. Right? Could not be more wrong :)
In a test run I've calculated similarities for 2199 recipes and in an average of 3 runs it took 1530 seconds. 
In this run the ingredient vector had to be calculated for all recipes, but the dot product 'only' for 2199 * 182184 (number of all recipes).
One way to check how will it scale is to check the profiler and see the procentage of time each step consumed:

![](data/2016-11-28-How-to-calculate-17-billion-similarities/profiler01.png)

Well bummer to put it lightly. Almost all time went into calculating the dot product (named here Cos). So calculating it for all recipes will take:

```    
    (1530/2199) * 182184 ~ 34 hours
```

So the next step will be:
 
## Optimising

### Less means faster

> The fastest code is the code that never runs

Going with this mantra I removed the ingredients that are not used by any recipe. 
This reduced the length of the vector to 1709 and the time be a whopping 562 seconds to 968 second. With some math we end up with **22,3 hours**
So case closed? No I I believe I can do better. To have an idea let's have a look at the profiler:

![](data/2016-11-28-How-to-calculate-17-billion-similarities/profiler02.png)

There did all the time go? Let's have a look at another view:

![](data/2016-11-28-How-to-calculate-17-billion-similarities/profiler03.png)

Yup it went into into native code meaning in my case multiplying floats and iterating over the array. So this idea is a dead end. so let's change the angle.

I know that this vector are very sparse (in average one recipe has ~100 non zero values). I am multiplying zero. So let's remove them.

### Use a dictionary
The idea behind this take is:

- it will allow me to store only those ingredients that the recipe has. This way the vector will shrink by a order of magnitude.
- since it is a dictionary, so checking if there is an ingredient with a given id will be fast. This will take care of multiplying zeros
- since I shrunk the vector I don't need to enumerate over all the ingredients, but only over those from one of the vectors
     
So let's but it into code:
```csharp

```