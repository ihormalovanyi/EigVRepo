TMP description =)

EigV provides a LAPACK-based function to compute a matrix's eigenvalues and eigenvectors. 

What are the eigen-guys for? Actually, as Swift devs, you most likely won't need them. But suppose you want to dive deep into Google's page rank algorithm, ML basics, Markov process, even in real physics, biological, or quantum mechanics, etc... In that case, the fundamental step is getting the eigen-guys. 

A super lightweight function in Python does it in one line of code. 

So, I researched the possibilities for efficient and correct computation in Swift. Unfortunately, I found a couple of outdated libraries that don't provide correct results. 

Next, I found the built-in (in Accelerate framework) function called dgeev_. It accepts 14 parameters and actively overuses in-out mechanics. I spent a few days playing with the function, researching its documentation, and making an imaginary-values correcting logic. 

Now, I am glad to share a lightweight and efficient function that works 33% faster than in Python. (A rough measurement, but ...).

You can Buy Me a Coffee. It helps me to continue doing the cool stuff writing it here =) 

https://buymeacoffee.com/swiua
