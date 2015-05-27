#include <bout/RKScheme.hxx>
#include "RKSchemefactory.hxx"

////////////////////
// PUBLIC
////////////////////

//Initialise
RKScheme::RKScheme(Options *opts){
  //Currently not reading anything from the options here
};

//Cleanup
RKScheme::~RKScheme(){
  //In C++11 we can do vec.clear() ; vec.shrink_to_fit(); //Though this is non-binding
  //For now we provide support for older compilers using the following;
  //vec.clear(); //Destroys each vector member
  //vector<type>().swap(vec); //Creates an empty temp vector and swaps it into vec
  //The result is that the memory associated with vec is freed.

  //stageCoeffs
  for(int i=0,i<stageCoeffs.size();i++){
    stageCoeffs[i].clear();
    vector<BoutReal>().swap(stageCoeffs[i]);
  };
  stageCoeffs.clear();
  vector< vector<BoutReal> >().swap(stageCoeffs);


  //resultCoeffs
  for(int i=0,i<resultCoeffs.size();i++){
    resultCoeffs[i].clear();
    vector<BoutReal>().swap(resultCoeffs[i]);
  };
  resultCoeffs.clear();
  vector< vector<BoutReal> >().swap(resultCoeffs);
   
  //steps
  for(int i=0,i<steps.size();i++){
    steps[i].clear();
    vector<BoutReal>().swap(steps[i]);
  };
  steps.clear();
  vector< vector<BoutReal> >().swap(steps);

  //timeCoeffs
  timeCoeffs.clear();
  vector<BoutReal>().swap(timeCoeffs);
};

//Returns the evolved state vector along with an error estimate
RKScheme::take_step(BoutReal curtime, BoutReal dt, BoutReal *start, BoutReal *resultFollow, 
			  BoutReal *resultAlt, BoutReal errEst){
};

////////////////////
// PRIVATE
////////////////////

//Print out details of the scheme
void RKScheme::debugPrint(){
};

void RKScheme::setStageCoeffs(int stage, const vector<BoutReal> coeffs){
};

void RKScheme::setResultCoeffs(int stage, const BoutReal highOrder, const BoutReal lowOrder){
};

void RKScheme::setTimeCoeffs(int stage, const BoutReal coeff){
};
