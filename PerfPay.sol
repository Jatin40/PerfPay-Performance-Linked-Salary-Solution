pragma solidity ^0.8.0;

contract PerfPay {
    struct Employee {
        uint8 workEffectivenessScore;
        uint8 timelinessFactor;
        uint8 behaviorScore;
        uint basicSalary;
        uint travelExpense;
        uint incentives;
        uint leavePenalty;
    }

    mapping(address => Employee) public employees;

    event SalaryCalculated(address indexed employee, uint salary);

    function setEmployeeData(address _employee, uint8 _workEffectivenessScore, uint8 _timelinessFactor, uint8 _behaviorScore, uint _basicSalary, uint _travelExpense) public {
        require(_workEffectivenessScore >= 1 && _workEffectivenessScore <= 10, "Invalid work effectiveness score");
        require(_timelinessFactor >= 1 && _timelinessFactor <= 10, "Invalid timeliness factor");
        require(_behaviorScore >= 1 && _behaviorScore <= 10, "Invalid behavior score");

        employees[_employee] = Employee(_workEffectivenessScore, _timelinessFactor, _behaviorScore, _basicSalary, _travelExpense, 0, 0);
    }

    function calculateAndDistributeSalary(address _employee) public {
        require(employees[_employee].workEffectivenessScore > 0, "Employee data not set");

        uint incentives = calculateIncentives(_employee);
        employees[_employee].incentives = incentives;

        uint salary = employees[_employee].basicSalary + employees[_employee].travelExpense + incentives - employees[_employee].leavePenalty;

        emit SalaryCalculated(_employee, salary);
    }

    function calculateIncentives(address _employee) internal view returns (uint) {
        uint rating = (employees[_employee].workEffectivenessScore + employees[_employee].timelinessFactor + employees[_employee].behaviorScore) / 3;
        
        if (rating == 1) {
            return 100;
        } else if (rating == 2) {
            return 200;
        } else if (rating == 3) {
            return 300;
        } else if (rating == 4) {
            return 400;
        } else if (rating == 5) {
            return 500;
        } else if (rating == 6) {
            return 1000;
        } else if (rating == 7) {
            return 1500;
        } else if (rating == 8) {
            return 2000;
        } else if (rating == 9) {
            return 3000;
        } else if (rating == 10) {
            return 5000;
        } else {
            return 0;
        }
    }

    function updateLeavePenalty(address _employee, uint _penalty) public {
        employees[_employee].leavePenalty = _penalty;
    }
}
