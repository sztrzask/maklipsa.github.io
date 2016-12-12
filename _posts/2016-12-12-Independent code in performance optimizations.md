---
layout: post
title: Independent code in performance optimizations
description: "The fastest code is the one that doesn't execute. Second to that is the one that executes once"
modified: 2016-12-11
tags: [.NET, cookit, performance, similarity]
image:
  feature: data/2016-12-12-Independent-code-in-performance-optimizations/logo.jpg
---

This will be a fast errata to the [previous one](/How-to-calculate-17-billion-similarities/). This time I will expand the oldest performance mantra:

> The fastest code is the one that doesn't execute. Second to that is the one that executes once


Last time I've forgot to mention one very important optimization. It was one of two steps that allowed me to go [from 1530 to 484 seconds](/How-to-calculate-17-billion-similarities/) in the sample run. 

<!--MORE-->

## Saga

Before I go further here are some link to the previous posts on the problem of calculating similarities and then optimizing it grew to few post. Here are all of them:

- [How I calculate similarities in cookit?](/How_I_calculate_similarities_in_cookit)
- [How to calculate 17 billion similarities](/How-to-calculate-17-billion-similarities)
- [Independent code in performance optimizations](/Independent-code-in-performance-optimizations)
- [Using bit masks for high performance calculatons](/Using-bit-operations-for-performance-optimizations)

Let's look once more at the code:

```csharp
public float Similarity(IDictionary<int,float> otherVector)
{
    var num = this
        .Sum(ingredient =>
        {
            float value = 0;
            if (otherVector.TryGetValue(ingredient.Key, out value))
                return ingredient.Value*value;
            return 0;
        });

    var denom = Lengh()*otherVector.Length();
    return num/denom;
}
```
and Length looking like this:

```csharp
public float Length(Vector a){    
    return (float)Math.Sqrt(a.Sum(value => value*value));
}
```

`Similarity` will be called for every pair of recipes and that means a lot:

```console
(182184*182184)/2 = 16 595 504 928 times 
```  

But there is one fragment that doesn't change depending on input parameters, so it means i can calculate it less often.<br/>
Can You spot it?

It's Length.

Changing it's code to this:

```csharp
public float Length()
{
    if (_wasIngredientWeightsChanged)
    {
        _len = (float) Math.Sqrt(_ingredientWeightsInternal.Values.Sum(value => value*value));
        _wasIngredientWeightsChanged = false;
    }
    return _len;
}
```

Allowed me to go from 968 seconds to 745 seconds for the sample. Scaling it to all recipes gives:

```console    
(745 / 2199) * 182184 ~ 17 hours (starting from 34 hours)
```

## Conslusion

*"Can I make it faster"* is not the only question to ask when optimizing. Sometimes asking *"does it have to execute this often?"* is also a very valid question.