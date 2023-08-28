#pragma once

#include "ADKernel.h"

/**
 *
 */
class ADMatAdvection : public ADKernel
{
public:
  static InputParameters validParams();

  ADMatAdvection(const InputParameters & parameters);

protected:
  const ADVectorVariableValue & _velocity;
  const ADMaterialProperty<Real> & _coeff;
  virtual ADReal computeQpResidual() override;
};
