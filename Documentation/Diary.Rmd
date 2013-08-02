Titanic project
========================================================
### Iteration 1  - Submitted
Plain vanilla classification tree
Data transformation includes:
* Assigning proper classes to each column of the data
* Fill missing age with median value of the age column - Improve it!
* Use in modeling only columns: survived,sex,pclass,age,sibsp,parch
* Use classification tree to model the data

*10 fold cross validation score:* 0.7921348

*Leave on out cross validation:* 0.7182941

*Submission score:* 0.75598


### Iteration 2 - submitted
Lets try some random forest
* Same data as above
* The model had parameter mtry=4, the rest was default

*10 fold cross validation score:* 0.8235955

*Leave on out cross validation:* 0.8226712

*Submission score:*  0.64115



### Iteration 3 - Submitted - INCORRECT!
The previous models didn't do very well. Now I will play a bit more with data
* Use simple classification tree to do the modelling
* Calculate title from name
* Use it to guess the age
* Do NOT use title in modelling it gave me some strange results
* There is definately some improvement with respect to my first model


*10 fold cross validation score:* 0.788764

*Leave on out cross validation:* 0.7968575

*Submission score:* 0.76555 - same as gender model benchmark

#### Note that this submission is INCORRECT!!!! I forgot to uncomment part of the code were I calculate missing age!
Some of the content of the file may be incorrect with respect to submission file!


### Iteration 4 - Submitted
I would like to try here something else, to apply two separate models, one for men, one for women.
How about use random forest on each women and men separetely?

* Here I am doing a decission tree on each gender separately
* I am also prunning the tree to 4 nodes for female and 5 nodes for men
* The prunning was based on analysis of images created by cv.tree
* I am using the age guesses from Iteration 3

*10 fold cross validation score:* -- cv.tree used

*Leave on out cross validation:* -- cv.tree used 

*Submission score:* 0.75598 - Not a great score, but I will leave it as is.

- - - 

### Iteration 5
I will add some new data here with respect to Iteration 4
* Add a family column - sibsp+parch+1 - this gives an estimate of number of family members on board
*

- - - 


### Iteration 6 - Submitted
Same as iteration 3 but with correct age calculated! I forgot there to uncomment the part of code where I calculate age!
So a new submission here! This is by now my best submission and it proves that age is very important!

*10 fold cross validation score:* 0.8146067

*4 fold cross validation minimal score:* 0.7792793 

*Leave on out cross validation:* 0.8237935

*Submission score:*  0.78947 - this is 439 position in leaderboard!


### Iteration 7 - Submitted
The same as iteration 6 but with age even more improved. I noticed that most of the age is missing for "Mr" and that the average age depends on pclass. So I will build a better model of age.
* Now age model includes title and pclass 
* Note: on first submission i made a mistake to including title in my data and again i got some crazy result!

*10 fold cross validation score:* 0.8213483

*Leave on out cross validation:* 0.8282828

*Submission score:* 0.79426 - this is 159 position in leaderboard!

- - -

### Iteration 8

### Iteration 9 - Submitted
The same as 7. - Classification tree
* Added number of family members on board calculation

*10 fold cross validation score:* 0.8269663

*Leave on out cross validation:* 0.8271605

*Submission score:* 0.78947 - Not an improvement! I must be overfitting.

### Iteration 10 - Submitted
Same as 9 but with random forest!
* I use random forest code from Iteratioin 2
* Used 5 features and 200 trees


*Score on training set:* 0.93 

*Submission score:* 0.72727

So low always from random forest!!! Why??? Thye must be overfitting a lot

### Iteration 11 - Submitted
Same as 10 but with many more trees. I used 
* used 800 tress and 4 features


*Score on training set:* 0.9203143 

*Submission score:* 0.75598

Again low.... I don't understand!

### Iteration 12  - Submitted
Same as 11 but changed random forest parameters. Now only three features in training! and 1000 trees
* Also used sampsize=400 to be comparable with the test set!

*Score on training set:* 0.87

*Submission score:* 0.78469

### Iteration 13 - Submitted
Lets try my last submission to be with different number of max nodes for random forest
* Set max nodes to 4

randomForest(survived~.,data=train,mtry=4,ntree = 1000,sampsize=300,maxnodes=4)

*Score on training set:* 0.81

*Submission score:* 0.77512
 :((((

### Iteration 14
This is a come back to classification tree.
I wanted to check if i can improve things by fitting womrn and men separately with the family column included.

- - -
### Ideas
* Improve age with pclass!
* model the age based on both training and testing sets.
* I wonder if SVM would improve the classification with some vertical boundaries.


