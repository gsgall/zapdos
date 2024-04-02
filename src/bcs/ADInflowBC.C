//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADInflowBC.h"
#include "Function.h"

registerMooseObject("ZapdosApp", ADInflowBC);

InputParameters
ADInflowBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addRequiredCoupledVar("velocity", "The velocity vector");
  params.addRequiredParam<Real>("value", "The value of the variable at the inlet");
  return params;
}

ADInflowBC::ADInflowBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters),
    _velocity(adCoupledVectorValue("velocity")),
    _value(getParam<Real>("value"))
{
}

ADReal
ADInflowBC::computeQpResidual()
{
  return _test[_i][_qp] * _value * _velocity[_qp] * _normals[_qp];
}
