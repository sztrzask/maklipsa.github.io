---
layout: post
title: How I calculate similarities in cookit? 
description: "How to define similarity between two objects? Worst yet. How to calculate it. This post describes the modeling process for defining similarity between recipes."
modified: 2016-11-28
tags: [.NET, cookit, performance, math]
image:
  feature: data/2016-11-28-How_I_calculate_similarities_in_cookit/logo.jpg
---
> Warning this post contains some math. Even more, it shows how to use it for solving real life problems. 

This post describes how I calculate similarity between recipes in my pet project [cookit.pl](http://cookit.pl). For those of you that don't know, cookit is a search engine for recipes. It crawls websites extracting recipe texts, then it parses it and tries to create a precise ingredient list with amounts and units.

By the time of writing it had:

- 182 184 recipes 
- 2936 ingredients

This scale may not seem huge, but trust me. It is enough to show many problems. Things get more complicated by the fact that cookit runs on a [crappy server (partly by choice)](http://indexoutofrange.com/The-importance-of-running-on-crapp/).

But those problems will be real lets first answer this question: 
<!--MORE-->

## How to calculate similarities?
The first question to ask is: 
    *How do you calculate similarity between two articles, recipes, objects in general ?* 
Let's use math! If we could express an object as a series of ordered numbers (a vector) then there are many ways do express how two vectors are similar to each other.

So how do we express a recipe as a vector? My answer was: 
    *If they have similar ingredients they are similar*
This translates into the need to build, for each recipe, a vector of ingredients where 0 represents the lack of ingredient and 1 its presence.  

Then I could express similarity between recipes as the number of common ingredients (do an AND operation and count all the ones). So case closed? Not exactly. This design has some problems.

## Building a similarities vector

Let's consider some cases where the initial idea will be too much of a simplification.

### Taking similarity into account

Let's take two recipes. One containing `sea salt` and the other `salt`. In the boolean representation, the similarity between them would be equal  to zero. But in real life they are similar. And often can be used interchangeably. They are not the same but similar. Now how to represent that?

I can take the advantage of the fact that all ingredients in cookit are organized in a graph. Where the child is more specific than the parent. For example, in this case, I have:

`Spices -> solid spices -> mineral spices -> salt -> sea salt`

We can take advantage of this knowledge and put all parents and children into the vector as owned ingredients. But then I loose the significance of the actual ingredient used (meaning that `sea salt` for this recipe is ideal, and `salt` is just OK). The best way would be to use weights on how accurate the ingredient is for this recipe. So my vector will look like this:

|---
| | Spices | Solid spices | Mineral spices | Salt | Sea salt
|:-|:-|:-|:-|:-|:-|:-
| Recipe with `salt` | (1\*y)\*y | (1\*y)\*y | (1\*y) | 1 | (1\*x)
| Recipe with `salt`(numbers) | 0.512 | 0.64 | 0.8 | 1 | 0.9
|---
| Recipe with `sea salt`| ((1\*y)\*y)\*y | ((1\*y)\*y)\*y | (1\*y)\*y | 1\*y | 1
| Recipe with `sea salt`(numbers) | 0.4096 | 0.512 | 0.64 | 0.8 | 1

where:

 - x is in the range of 0-1 and is the penalty for being further away for children 
 - y is in the range of 0-1 and is the penalty for being further away for parents

### Adding importance

Let's take *scrambled eggs*. It's ingredients are:

- `eggs`
- `salt` 
- `pepper`

And let's take a *steak*. It's ingredients are: 

- `meat`
- `salt` 
- `pepper` 

If we calculate similarities with the current model those two will be very similar (about 66%). This is because we treat every ingredient with the same importance. And this is not right. So how do I calculate ingredient's importance? Easily, using the same idea as Lucene - [inverted index](https://en.wikipedia.org/wiki/Inverted_index):

```
Sum of recipes having ingredient x / Sum of all ingredients in all recipes
```

Because `salt` and `pepper` is a very popular ingredient their weight will be very small. `Meat` and `eggs` are less popular, so they will have a higher weight. Also, it has the neet feature that it is [normalized](https://en.wikipedia.org/wiki/Normalization_(statistics)) in zero to one range. 

So, for now, the model looks good.

## Calculating the vector
 
Let's move all that knowledge to code:

```csharp
float[] vector = new float[NUMBER_OF_ALL_INGREDIENTS]
 
foreach(var ingredient in recipe.Ingredients){
    SetIngredientWeight(ingredient,vector,1);
}

private void SetIngredientWeight(Ingredient ing,float[] vector,float weight){
    vector[ing.Id] = weight//set the weight for the current ingredient
    foreach(var parent in ing.Parents)
        SetIngredientWeight(parent,vector,weight*0.8) //go recursivly over each parent and add them with smaller weight
    foreach(var child in ing.Children) //do the same for children
        SetIngredientWeight(child,vector,weight*0.9)
}
```
What is happening:

I iterate over all ingredients existing in the recipe and set the weight to 1. Then I go recursively up and down the ingredient tree and set the weights for parents and children. The further away from the original ingredient the less significant the ingredient is. So the weight is lowered (this is taken care by the `weight*0.9` part in `SetIngredientWeight`)

This gives me a vector representation of every recipe. The "only" thing left is to figure a way to compare two vectors.

## Calculating similarity

Ok, I have recipes represented as a vector of floats. Now how to convert two of those vectors into a single digit, from zero do one, representing how similar they are. How to do it?
  
Luckily math has figured this long time ago:) There are many algorithms that can be helpful, but the most common, and a good start, is calculating the [dot product](https://en.wikipedia.org/wiki/Dot_product):
 
![dot product](/data/2016-11-28-How_I_calculate_similarities_in_cookit/dot_product.gif)

To explain how it works let's assume that our vectors are two-dimensional (it is like saying that every dish can be made from a combination of only two ingredients). Then we can draw them like this (image taken from Wikipedia):

![two dimentional dot product](https://upload.wikimedia.org/wikipedia/commons/thumb/3/3e/Dot_Product.svg/220px-Dot_Product.svg.png)

So what it does, is projects one vector onto another (the cosine part takes care of it). This gives it's length relative to the other vector. Relative values are nice but useless. Why? Comparing similarity of A and B to similarity of A and C would be comparing the length of A projected onto B and A projected onto C. Divisors are not the same, thus the comparison has no sense. One way to deal with it is to normalize the value to one range (most common is from zero to one). This is simple. Just divide the shorter vector, or projection, by the length of the longer, projection. <br/>
As [ComicStrip](http://www.commitstrip.com/) says:<br/>
![](http://www.commitstrip.com/wp-content/uploads/2016/08/Strip-Les-specs-cest-du-code-650-finalenglish.jpg)

Lets putting all of it into C#:

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

```csharp
public float Length(Vector a){    
    return (float)Math.Sqrt(a.Sum(value => value*value));
}
```

So all well then? Far from it. But this will be the topic of the next post. Stay tune, [rss](http://indexoutofrange.com/feed.xml), [follow](https://twitter.com/maklipsa), or just don't close to browser window ;)