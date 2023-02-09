#include "tools.hpp"
#include <iostream>
#include <Eigen/Core>

int main()
{
  MakeItRain();
  MakeItSunny();

  Eigen::MatrixXd mat = Eigen::MatrixXd::Ones(6, 6);
  std::cout << mat << std::endl;

  return 0;
}