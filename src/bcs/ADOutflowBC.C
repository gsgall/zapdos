//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ADOutflowBC.h"
#include "Function.h"

registerMooseObject("ZapdosApp", ADOutflowBC);

InputParameters
ADOutflowBC::validParams()
{
  InputParameters params = ADIntegratedBC::validParams();
  params.addRequiredCoupledVar("velocity", "The velocity vector");
  return params;
}

ADOutflowBC::ADOutflowBC(const InputParameters & parameters)
  : ADIntegratedBC(parameters), _velocity(adCoupledVectorValue("velocity"))
{
}

ADReal
ADOutflowBC::computeQpResidual()
{
  return _test[_i][_qp] * _u[_qp] * _velocity[_qp] * _normals[_qp];
}
