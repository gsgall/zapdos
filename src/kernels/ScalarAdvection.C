//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "ScalarAdvection.h"

registerADMooseObject("ZapdosApp", ScalarAdvection);

InputParameters
ScalarAdvection::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addRequiredCoupledVar("velocity", "The velocity vector");
  params.addClassDescription(
      "Scalar Transport kernel");
  return params;
}

ScalarAdvection::ScalarAdvection(const InputParameters & parameters)
  : ADKernel(parameters),
   _velocity(adCoupledVectorValue("velocity"))
{
}

ADReal
ScalarAdvection::computeQpResidual()
{
  return _test[_i][_qp] * _velocity[_qp] * _grad_u[_qp];
}
