#include "ADMatTimeDerivative.h"

registerMooseObject("ZapdosApp", ADMatTimeDerivative);

InputParameters
ADMatTimeDerivative::validParams()
{
  InputParameters params = ADTimeKernelValue::validParams();
  params.addClassDescription("The time derivative operator with the weak form of $(\\psi_i, "
                             "\\frac{\\partial u_h}{\\partial t})$.");
  params.addRequiredParam<MaterialPropertyName>("coeff_name",
                                                "The coeff to multiply by the advection term");
  return params;
}

ADMatTimeDerivative::ADMatTimeDerivative(const InputParameters & parameters)
  : ADTimeKernelValue(parameters), _coeff(getADMaterialProperty<Real>("coeff_name"))
{
}

ADReal
ADMatTimeDerivative::precomputeQpResidual()
{
  return _coeff[_qp] * _u_dot[_qp];
}
