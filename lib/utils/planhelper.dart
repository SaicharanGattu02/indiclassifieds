import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:indiclassifieds/Components/CustomAppButton.dart';

import '../data/cubit/UserActivePlans/user_active_plans_cubit.dart';
import '../data/cubit/UserActivePlans/user_active_plans_states.dart';
import '../model/UserActivePlansModel.dart';
import '../theme/AppTextStyles.dart';
import '../theme/ThemeHelper.dart';

void showPlanBottomSheet({
  required BuildContext context,
  required TextEditingController controller,
  required Function(Plans) onSelectPlan,
  String? title = 'Select Plan',
}) {
  showModalBottomSheet(
    backgroundColor: ThemeHelper.backgroundColor(context),
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ),
    builder: (context) {
      return BlocBuilder<UserActivePlanCubit, UserActivePlanStates>(
        builder: (context, state) {
          final textColor = ThemeHelper.textColor(context);
          final cardColor = ThemeHelper.cardColor(context);

          if (state is UserActivePlanLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is UserActivePlanFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 40),
                  SizedBox(height: 10),
                  Text(
                    'Error loading plans',
                    style: AppTextStyles.bodyLarge(textColor),
                  ),
                ],
              ),
            );
          }

          if (state is UserActivePlanLoaded) {
            final plans = state.userActivePlansModel.plans ?? [];
            if (plans.length == 0) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Oops!",
                        style: TextStyle(
                            color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800
                        ),
                      ),
                      Text(
                        "You don't have Plans. Please Subscribe for Plan.",
                        style: TextStyle(
                          color: textColor
                        ),
                      ),
                      CustomAppButton1(text: "Subscribe",width: 250, onPlusTap: () {
                        context.pop();
                        context.push("/plans");
                      }),
                    ],
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        title,
                        style: AppTextStyles.headlineMedium(textColor),
                      ),
                    ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.only(bottom: 12),
                          color: cardColor,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              plan.planName ?? 'No name',
                              style: AppTextStyles.titleLarge(textColor),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan.packageName ?? 'No package',
                                  style: AppTextStyles.bodyMedium(textColor),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Start Date: ${plan.startDate}',
                                  style: AppTextStyles.bodySmall(textColor),
                                ),
                                Text(
                                  'End Date: ${plan.endDate}',
                                  style: AppTextStyles.bodySmall(textColor),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.text =
                                  plan.planName ??
                                  ''; // Set the selected plan name in the text field
                              onSelectPlan(
                                plan,
                              ); // Callback function when a plan is selected
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1.5,
                        color: textColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Text(
              'No plans available',
              style: AppTextStyles.bodyMedium(textColor),
            ),
          );
        },
      );
    },
  );
}
