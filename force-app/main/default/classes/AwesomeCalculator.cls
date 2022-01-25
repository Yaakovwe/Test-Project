public class AwesomeCalculator {
    public static Double add(Double x, Double y) {
        CalculatorServices.CalculatorImplPort calculator = 
            new CalculatorServices.CalculatorImplPort();
        return calculator.doAdd(x,y);
    }
}