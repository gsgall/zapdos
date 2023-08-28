//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "CoupledVectorValueIC.h"
#include "libmesh/point.h"

registerMooseObject("ZapdosApp", CoupledVectorValueIC);

InputParameters
CoupledVectorValueIC::validParams()
{
  InputParameters params = VectorInitialCondition::validParams();
  params.addCoupledVar(
      "x_component", 0, "A function that describes the x-component of the initial condition");
  params.addCoupledVar(
      "y_component", 0, "A function that describes the y-component of the initial condition");
  params.addCoupledVar(
      "z_component", 0, "A function that describes the z-component of the initial condition");
  params.addClassDescription(
      "Sets component values for a vector field variable based on a vector function.");
  return params;
}

CoupledVectorValueIC::CoupledVectorValueIC(const InputParameters & parameters)
  : VectorInitialCondition(parameters),
    _x(coupledValue("x_component")),
    _y(coupledValue("y_component")),
    _z(coupledValue("z_component"))
{
}

RealVectorValue
CoupledVectorValueIC::value(const Point & /*p*/)
{
  return RealVectorValue(_x[_qp], _y[_qp], _z[_qp]);
}
