//* This file is part of Zapdos, an open-source
//* application for the simulation of plasmas
//* https://github.com/shannon-lab/zapdos
//*
//* Zapdos is powered by the MOOSE Framework
//* https://www.mooseframework.org
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#include "BackgroundFluxVector.h"

registerADMooseObject("ZapdosApp", BackgroundFluxVector);

InputParameters
BackgroundFluxVector::validParams()
{
  InputParameters params = ADKernel::validParams();
  params.addRequiredCoupledVar("velocity",
                               "The velocity vectory driving of the bulk fluid in the system");
  params.addClassDescription("Provides a flux term in with the strong form $u \\vec{v}$."
                             "Densities must be in log form."
                             "This kernel expects velocity as a vector.");
  return params;
}

BackgroundFluxVector::BackgroundFluxVector(const InputParameters & parameters)
  : ADKernel(parameters), _velocity(adCoupledVectorValue("velocity"))
{
}

ADReal
BackgroundFluxVector::computeQpResidual()
{
  return -_grad_test[_i][_qp] * std::exp(_u[_qp]) * _velocity[_qp];
}
