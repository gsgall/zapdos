
#pragma once

#include "ADTimeKernelValue.h"

class ADMatTimeDerivative : public ADTimeKernelValue
{
public:
  static InputParameters validParams();

  ADMatTimeDerivative(const InputParameters & parameters);

protected:
  const ADMaterialProperty<Real> & _coeff;
  virtual ADReal precomputeQpResidual() override;
};
