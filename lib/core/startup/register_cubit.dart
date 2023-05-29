import 'package:get_it/get_it.dart';
import 'package:sonalysis/core/datasource/local_data_cubit.dart';
import 'package:sonalysis/core/enums/server_type.dart';
import 'package:sonalysis/core/network/network_service.dart';
import 'package:sonalysis/features/common/cubit/common_cubit.dart';
import 'package:sonalysis/features/common/service/service.dart';
import 'package:sonalysis/features2/inital_update_profile/cubit/initial_update_profile_cubit.dart';
import 'package:sonalysis/features2/login/cubit/login_user_cubit.dart';
import 'package:sonalysis/features2/login/service/service.dart';
import 'package:sonalysis/features2/settings/cubit/settings_cubit.dart';
import 'package:sonalysis/features2/settings/service/service.dart';
import 'package:sonalysis/features2/signup/cubit/signup_cubit.dart';
import 'package:sonalysis/features2/signup/service/service.dart';

import '../../features2/inital_update_profile/service/service.dart';
import '../../features2/recover_password/cubit/preset_cubit.dart';
import '../../features2/recover_password/service/service.dart';
import '../../features2/splash/cubit/splash_cubit.dart';
import '../../features2/splash/service/service.dart';

void registerCubit(GetIt serviceLocator) {
  serviceLocator.registerSingleton(
    LoginUserCubit(
      LoginUserService(
        newServerService: NetworkService(ServerType.newServer),
        oldServerService: NetworkService(ServerType.oldServer),
      ),
    ),
  );
serviceLocator.registerSingleton(
    CommonCubit(
      CommonService(
        newServerService: NetworkService(ServerType.newServer),
        oldServerService: NetworkService(ServerType.oldServer),
      ),
    ),
  );
serviceLocator.registerSingleton(
  SettingsCubit(
    SettingsService(
        newServerService: NetworkService(ServerType.newServer),
      ),
    ),
  );
serviceLocator.registerSingleton(
  SplashCubit(
    SplashService(
        newServerService: NetworkService(ServerType.newServer),
      ),
    ),
  );

serviceLocator.registerSingleton(
  PasswordResetCubit(
    PasswordResetService(
        myService: NetworkService(ServerType.newServer),
      ),
    ),
  );

serviceLocator.registerSingleton(
  InitialUpdateProfileCubit(
    InitialUpdateProfileService(
        myService: NetworkService(ServerType.newServer),
      ),
    ),
  );

serviceLocator.registerSingleton(
  SignupCubit(
    SignupService(
        myService: NetworkService(ServerType.newServer),
      ),
    ),
  );

serviceLocator.registerSingleton(
  LocalDataCubit(),
  );
}
