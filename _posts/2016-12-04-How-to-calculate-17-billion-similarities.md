---
layout: post
title: How to calculate 17 billion similarities
description: "How to calculate similarity between two objects? Worst yet how to calculate 17 billion of them?"
modified: 2016-12-05
tags: [.NET, cookit, performance, math]
image:
  feature: data/2016-12-05-How-to-calculate-17-billion-similarities/logo.jpg
---

The [previous post](/How_I_calculate_similarities_in_cookit/) described the methodology I've used to calculate similarities between recipes in [cookit](http://cookit.pl). If You haven't read it give it 4 minutes because it will make understanding this post easier. It ended on a happy note and everything seemed to be down hill from there on. <br/>
It was until I tried to run it. It took long. Very long. How long? I don't know because I've canceled it after about one hour. Going with a famous quote (probably from Einstein, but there [are some ambiguities in this subject](https://www.quora.com/Did-Einstein-really-define-insanity-as-doing-the-same-thing-over-and-over-again-and-expecting-different-results)) 

> Doing the same thing over and over again and expecting different results

I've decided to once again use math to calculate just what am I dealing with here.   

## Complexity

Just a reminder. Cookit currently has:

- 182 184 recipes 
- 2936 ingredients

As a consequence of the way I model similarities, I will need to create for each recipe a 2936 dimentional array representing ingredients. This gives me 534 892 224 floats. If we do a simple calculation: 

```
534 892 224 * 4(the size of float) ~ 2.14 Gig counting only space needed for floats
```

And if I will want to calculate the similarities I will have to do:

```
((182 184 * 2 936)^2) /2 = 143 054 845 647 833 100 floating point multiplications
```

So citing [Mark Watney](https://en.wikipedia.org/wiki/The_Martian_(Weir_novel))
 
> I will have to science the sh** out of it :)

## Calculating similarity - array multiplication

In the [previous post](/How_I_calculate_similarities_in_cookit/) I've decided to calculate similarity by calculating the dot product between recipe ingredient vectors. In C# it will look more or less like this:
 
```csharp public float Similarity(Vector a, Vector b){    
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

## Assesing total time

To get a scale how long will it take I've decided to do a test run on a subset of recipes. Recipes from selected websites summed up to 2199. Then I've made 3 test runs ([I've learned the hard way that one test run dosen't mean anything](http://indexoutofrange.com/LocalOptimizationsDontAddUp/)) and it took in average 1530 seconds. <br/>

I can't use just this time to asses the total execution time because it consists from two parts:

- calculating ingredient vector for all recipes. 
- finding similar recipes for only 2199 one of them. Similarity is found by calculating one vector by all the others. So in this case I've done  
	
```
182184*2199 = 400 622 616 vector multiplications
```

The first part is constant regardless how many similarities I will have to calculate.
The second part is directly proportional to the number of recipes for which I will calculate similarities.

The last part missing for assesing the time of calculation for all recipes is the proportion of those two operations. So let's fire up the profiler ([dotTrace](https://www.jetbrains.com/profiler/) by choice) in sampling mode:
![](data/2016-12-05-How-to-calculate-17-billion-similarities/profiler01.png)

Well bummer to put it lightly. Almost all time went into calculating the dot product (named here Cos). This tels me that I can calculate the total time as a linear function without making to big of an error:

```    
(1530 / 2199) * 182184 ~ 34 hours

where:
- 1530 - number of seconds it took
- 2199 - number of recipes
- 182184 - number of recipes 
```


So the next step will be:
 
## Optimising

### Less means faster
 
> The fastest code is the code that never runs

Following this mantra I removed the ingredients that are not used by any recipe. 
This reduced the length of the vector to 1709 and the sample time be a whopping 562 seconds to 968 second. With some math we end up with **22,3 hours**
So case closed? No. I believe I can do better. To have an idea let's have a look with a profiler:

![](data/2016-12-05-How-to-calculate-17-billion-similarities/profiler02.png)

There did all the time go? Let's have a look at another view:

![](data/2016-12-05-How-to-calculate-17-billion-similarities/profiler03.png)

It went into into native code meaning in my case multiplying floats and iterating over the array. This means that this idea is a dead end. Let's change the angle and use domain knowledge to optimize a bit more.

### Using domain knowledge for optimization

I know that vectors are very [sparse](https://en.wikipedia.org/wiki/Sparse_array). In average one recipe has ~150 non zero values, so I am multiplying zero. Let's remove them.

### Use a dictionary

Instead of using an array I will use a dictionary. The idea behind this take is:

- it will allow me to store only those ingredients that the recipe has. This way the vector will shrink by a order of magnitude and as a side effect I will also shrink memory usage (although not that much since dictionary in .NET is a memory heavy structure)
- since I shrunk the vector I don't need to enumerate over all the ingredients, but only over those from one of the vectors
     
So let's but it into code:
```csharp

```